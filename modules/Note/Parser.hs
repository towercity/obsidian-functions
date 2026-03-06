module Note.Parser (parseNote) where

import Text.ParserCombinators.Parsec
import Control.Monad (void)

import Note.Types (FrontMatter, FrontMatterEntry, FrontMatterValue, Section)

-- Entry point
parseNote :: String -> (Maybe FrontMatter, [Section])
parseNote input = case parse noteParser "(input)" input of
  Left  _    -> (Nothing, [])
  Right result -> result

-- Top level
noteParser :: Parser (Maybe FrontMatter, [Section])
noteParser = do
  fm      <- optionMaybe (try frontMatter)
  content <- parseNoteText
  return (fm, content)

-- Front Matter
----

frontMatter :: Parser FrontMatter
frontMatter = do
  string "---"
  eol
  manyTill yamlEntry (try yamlEnd)

yamlEntry :: Parser FrontMatterEntry
yamlEntry = do
  key <- many1 (noneOf ":\n")
  char ':'
  optional (char ' ')
  values <- yamlValue
  return (key, values)

yamlValue :: Parser FrontMatterValue
yamlValue =
  try yamlValueMulti
  <|> try yamlValueWrappedSingle

-- multi-entry values always start with AND are separated by eols
yamlValueMulti :: Parser FrontMatterValue
yamlValueMulti = do
  eol
  many1 (string "  - " >> yamlValueSingle)

-- wraps single values to keep the same type as multi-entry values
yamlValueWrappedSingle :: Parser FrontMatterValue
yamlValueWrappedSingle = do
  value <- yamlValueSingle
  return [value]

-- always called with pre-filtered text, so we can just go to end of line
yamlValueSingle :: Parser String
yamlValueSingle = manyTill anyChar eol

yamlEnd :: Parser ()
yamlEnd = do
  string "---"
  optional (char '\n')

-- Note Content
----

parseNoteText :: Parser [Section]
parseNoteText = do
  pre  <- openingText
  rest <- many section
  return (pre : rest)

openingText :: Parser Section
openingText = do
  lines' <- mdLines
  return (Nothing, unlines lines')

section :: Parser Section
section = do
  title  <- h1
  lines' <- mdLines
  return (Just title, unlines lines')

mdLines :: Parser [String]
mdLines = manyTill mdLine (void (lookAhead h1) <|> eof)

h1 :: Parser String
h1 = do
  char '#'
  notFollowedBy (char '#')
  skipMany (char ' ')
  mdLine

mdLine :: Parser String
mdLine = manyTill anyChar (void eol <|> eof)

-- cross platform eol placeholder
eol :: Parser Char
eol = char '\n'
