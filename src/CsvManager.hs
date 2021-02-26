{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedStrings #-}

module CsvManager
  ( someFunc,
  )
where

import Data.Aeson (ToJSON, encode)
import qualified Data.ByteString.Lazy as LC
import Data.Csv (HasHeader (HasHeader), decode)
import qualified Data.Text as T
import qualified Data.Vector as V
import Row (CsvRow (..))
import SearchEngine (fromCsvRows, search)
import System.Environment (getArgs)
import System.IO (BufferMode (LineBuffering), hSetBuffering)

someFunc :: IO ()
someFunc = do
  (fileName : _) <- getArgs
  file <- readFileLBS fileName

  hSetBuffering stdin LineBuffering
  hSetBuffering stdout LineBuffering

  case decodeItems file of
    Left e -> putStrLn e
    Right xs -> do
      let searchengine = fromCsvRows xs

      forever $ do
        searchTerm <- T.toCaseFold . T.strip <$> getLine

        printJSON $ search searchTerm searchengine

decodeItems ::
  LC.ByteString ->
  Either String [CsvRow]
decodeItems =
  fmap V.toList <$> decode HasHeader

printJSON :: (ToJSON a) => a -> IO ()
printJSON = print . encode