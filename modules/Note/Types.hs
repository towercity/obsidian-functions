module Note.Types where

data Note = Note {
    filename    :: String
  , title       :: String
  , fm          :: Maybe FrontMatter
  , noteContent :: [Section]
} deriving (Show)

type FrontMatter      = [FrontMatterEntry]
type FrontMatterEntry = (String, FrontMatterValue)
type FrontMatterValue = [String]
type Section          = (Maybe String, String)
