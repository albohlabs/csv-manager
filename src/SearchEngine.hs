{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}

module SearchEngine (fromCsvRows, search) where

import Data.Char (isPunctuation)
import Data.Ix (Ix)
import Data.SearchEngine (NoFeatures, SearchConfig (..), SearchRankParameters (..))
import qualified Data.SearchEngine as SE
import qualified Data.Text as Text
import qualified NLP.Tokenize as NLP
import Row (CsvRow, indexableFields)

type SearchEngine = SE.SearchEngine CsvRow CsvRow SearchField NoFeatures

data SearchField = NameField
  deriving stock (Eq, Show, Ord, Enum, Bounded, Ix)

search :: Text -> SearchEngine -> [CsvRow]
search query searchEngine =
  SE.query searchEngine $ words query

fromCsvRows :: [CsvRow] -> SearchEngine
fromCsvRows rows =
  SE.insertDocs rows $
    SE.initSearchEngine searchConfig searchRankParams

searchRankParams :: SearchRankParameters SearchField NoFeatures
searchRankParams =
  SearchRankParameters
    { paramK1 = 1.5,
      paramB = const 1,
      paramFieldWeights = const 1,
      paramFeatureWeights = SE.noFeatures,
      paramFeatureFunctions = SE.noFeatures,
      paramResultsetSoftLimit = 200,
      paramResultsetHardLimit = 400,
      paramAutosuggestPrefilterLimit = 500,
      paramAutosuggestPostfilterLimit = 500
    }

searchConfig :: SearchConfig CsvRow CsvRow SearchField NoFeatures
searchConfig =
  SearchConfig
    { documentKey = id,
      extractDocumentTerms = extractTokens,
      transformQueryTerm = normaliseQueryToken,
      documentFeatureValue = const SE.noFeatures
    }

extractTokens :: CsvRow -> SearchField -> [Text]
extractTokens row NameField =
  map (Text.toCaseFold . Text.pack)
    . concatMap splitTok
    . filter (not . ignoreTok)
    . concatMap (NLP.tokenize . Text.unpack)
    . indexableFields
    $ row

ignoreTok :: String -> Bool
ignoreTok = all isPunctuation

splitTok :: String -> [String]
splitTok tok =
  case go tok of
    toks@(_ : _ : _) -> tok : toks
    toks -> toks
  where
    go remaining =
      case break (\c -> c == ')' || c == '-' || c == '/') remaining of
        ([], _ : trailing) -> go trailing
        (leading, _ : trailing) -> leading : go trailing
        ([], []) -> []
        (leading, []) -> [leading]

normaliseQueryToken :: Text -> SearchField -> Text
normaliseQueryToken query NameField = Text.toCaseFold query
