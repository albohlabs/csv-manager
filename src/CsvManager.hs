{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module CsvManager
  ( someFunc,
  )
where

import Data.Aeson (FromJSON, ToJSON, encode)
import qualified Data.ByteString.Lazy.Char8 as LC
import Data.Csv (FromNamedRecord (parseNamedRecord), decodeByName, (.:))
import qualified Data.Text as T
import qualified Data.Vector as V
import System.Environment (getArgs)
import System.IO (BufferMode (LineBuffering), hSetBuffering)

data Item = Item
  { itemSerialNumber :: Int,
    itemCompanyName :: Text,
    itemEmployeeMarkme :: Text,
    itemDescription :: Text,
    itemLeave :: Text
  }
  deriving stock (Generic, Eq, Show)
  deriving anyclass (FromJSON, ToJSON)

instance FromNamedRecord Item where
  parseNamedRecord m =
    Item
      <$> m .: "Serial Number"
      <*> m .: "Company Name"
      <*> m .: "Employee Markme"
      <*> m .: "Description"
      <*> m .: "Leave"

decodeItems ::
  LByteString ->
  Either String (V.Vector Item)
decodeItems =
  fmap snd . decodeByName

printJSON :: (ToJSON a) => a -> IO ()
printJSON = LC.putStrLn . encode

someFunc :: IO ()
someFunc = do
  (fileName : _) <- getArgs
  file <- readFileLBS fileName

  hSetBuffering stdin LineBuffering
  hSetBuffering stdout LineBuffering

  case decodeItems file of
    Left e -> LC.putStrLn . LC.pack $ e
    Right xs -> do
      printJSON xs

      forever $ do
        term <- T.toCaseFold . T.strip <$> getLine

        printJSON $ V.filter (hasTerm term) xs
  where
    hasTerm term Item {..} =
      term `T.isInfixOf` T.toCaseFold itemCompanyName
        || term `T.isInfixOf` show itemSerialNumber
        || term `T.isInfixOf` T.toCaseFold itemEmployeeMarkme
        || term `T.isInfixOf` T.toCaseFold itemDescription
        || term `T.isInfixOf` T.toCaseFold itemLeave
