{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE RecordWildCards #-}

module Row
  ( CsvRow (..),
    indexableFields,
  )
where

import Data.Aeson (FromJSON, ToJSON)
import Data.Csv (FromRecord)

data CsvRow = CsvRow
  { number :: Text,
    cardboardBox :: Text,
    count :: Text,
    image :: Text,
    gender :: Text,
    clothe :: Text,
    titleEtsy :: Text,
    desc :: Text,
    brand :: Text,
    flaws :: Text,
    color :: Text,
    size :: Text,
    tags :: Text,
    material :: Text,
    price :: Text,
    style :: Text
  }
  deriving stock (Generic, Eq, Show, Ord)
  deriving anyclass (FromJSON, ToJSON, FromRecord)

indexableFields :: CsvRow -> [Text]
indexableFields CsvRow {..} =
  [ number,
    cardboardBox,
    -- count,
    image,
    gender,
    clothe,
    titleEtsy,
    desc,
    brand,
    flaws,
    color,
    size,
    tags,
    material,
    -- price,
    style
  ]