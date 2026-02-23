{-# LANGUAGE MultilineStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module NoteParser (
    parseNote
  , NoteContent(..)
) where

import Text.ParserCombinators.Parsec
import Control.Monad (void)


data NoteContent = NoteContent {
    fm      :: Maybe FrontMatter
  , content :: NoteText
} deriving (Show)

type FrontMatter = [FrontMatterEntry]
type FrontMatterEntry = (String, FrontMatterValue)
type FrontMatterValue = [String]

type NoteText = [Section]
data Section = Section {
    title   :: Maybe String -- maybe bc of pre-heading text
  , content :: String
} deriving (Show)

note :: Parser NoteContent
note = do
  fm      <- optionMaybe (try frontMatter)
  content <- noteText
  return $ NoteContent fm content

-- Font Matter
----

frontMatter :: Parser FrontMatter
frontMatter = do
  string "---"
  eol
  entries <- manyTill yamlEntry (try yamlEnd)
  return entries

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

yamlValueMulti = do
  eol   -- multi-entry values always start with AND are separated by eols!
  value <- many1 (string "  - " >> yamlValueSingle)
  return value

-- we use this to properly wrap our single values to keep the same type as multi
-- entry values
yamlValueWrappedSingle = do
  value <- yamlValueSingle
  return [value]

-- we ALWAYS pass in pre-filtered text here, so we can just go to end of line
yamlValueSingle = manyTill anyChar eol

yamlEnd = do
  string "---"
  optional (char '\n')

-- Note Content
----

noteText :: Parser NoteText
noteText = do
  pre  <- openingText
  rest <- many section
  return (pre : rest)

openingText :: Parser Section
openingText = do
  lines' <- mdLines
  return $ Section Nothing (unlines lines')

section :: Parser Section
section = do
  title  <- h1
  lines' <- mdLines
  return $ Section (Just title) (unlines lines')

mdLines :: Parser [String]
mdLines = manyTill mdLine (void (lookAhead h1) <|> eof)

h1 :: Parser String
h1 = do
  char '#'
  notFollowedBy (char '#')
  skipMany (char ' ')
  heading <- mdLine
  return heading

mdLine :: Parser String
mdLine = manyTill anyChar (void eol <|> eof)

-- Other
----

-- yeah, we SHOULD do this cross platform. thus: at least a variable
eol = char '\n'

-- do all our parsing in this function for easy export!
parseNote :: String -> NoteContent
parseNote input = case (parse note "(input)") input of
  Left  err -> parseNote ""  -- at this point, dont care about errors
  Right note -> note
