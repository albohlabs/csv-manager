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
  { itemNumber :: Text,
    itemCardboardBox :: Text,
    itemCount :: Text,
    itemImage :: Text,
    itemGender :: Text,
    itemClothe :: Text,
    itemTitleEtsy :: Text,
    itemDesc :: Text,
    itemBrand :: Text,
    itemFlaws :: Text,
    itemColor :: Text,
    itemSize :: Text,
    itemTags :: Text,
    itemMaterial :: Text,
    itemPrice :: Text,
    itemStyle :: Text
  }
  deriving stock (Generic, Eq, Show, Ord)
  deriving anyclass (FromJSON, ToJSON, FromRecord)

indexableFields :: CsvRow -> [Text]
indexableFields CsvRow {..} =
  [ itemNumber,
    itemCardboardBox,
    -- itemCount,
    itemImage,
    itemGender,
    itemClothe,
    itemTitleEtsy,
    itemDesc,
    itemBrand,
    itemFlaws,
    itemColor,
    itemSize,
    itemTags,
    itemMaterial,
    -- itemPrice,
    itemStyle
  ]