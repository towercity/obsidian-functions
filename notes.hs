data Note = Note {
    filename :: String
  , title :: String
  , frontMatter :: Maybe [(String, String)]
  , content :: Maybe String
} deriving (Show)

parseNote :: String -> Note
parseNote x = Note {
    filename="test.md"
  , title="test"
  , frontMatter=Nothing
  , content=Just "test"
}
