{-# LANGUAGE MultilineStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot #-}

module ReadNote (
  Note(..)
  , NoteContent(..)
  , readNote
  , testNote
) where

import Data.List
import System.FilePath (takeFileName, takeBaseName)
import Text.ParserCombinators.Parsec
import Control.Monad (void)

testNote = Note {filename = "Harold Abelson and Gerald Jay Sussman - Structure and Interpretation of Computer Programs.md", title = "Harold Abelson and Gerald Jay Sussman - Structure and Interpretation of Computer Programs", noteContent = NoteContent {fm = Just [("tags",["book"]),("status",["reading"]),("rating",[""]),("aliases",["Structure and Interpretation of Computer Programs","SICP"]),("author",["\"[[Harold Abelson and Gerald Jay Sussman]]\""]),("title",["Structure and Interpretation of Computer Programs"]),("started",["\"[[2025-12-27]]\""]),("cover",["https://drive.konger.online/book-cover/sicp.png"])], noteText = [Section {title = Nothing, sectionText = "\n"},Section {title = Just "why i read", sectionText = "- gotta learn the programs!\n"},Section {title = Just "rev", sectionText = "\n"}]}}

data Note = Note {
    filename :: String
  , title :: String
  , noteContent :: NoteContent
} deriving (Show)

data NoteContent = NoteContent {
    fm      :: Maybe FrontMatter
  , noteText :: NoteText
} deriving (Show)

type FrontMatter = [FrontMatterEntry]
type FrontMatterEntry = (String, FrontMatterValue)
type FrontMatterValue = [String]

type NoteText = [Section]
data Section = Section {
    title   :: Maybe String -- maybe bc of pre-heading text
  , sectionText :: String
} deriving (Show)


makeNote :: String -> String-> Note
makeNote fileName fileContents =
  Note (takeFileName fileName)
       (takeBaseName fileName)
       (parseNote fileContents)

readNote :: String -> IO Note
readNote fileName = do
  file <- readFile fileName
  return (makeNote fileName file)



note :: Parser NoteContent
note = do
  fm      <- optionMaybe (try frontMatter)
  content <- parseNoteText
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

parseNoteText :: Parser NoteText
parseNoteText = do
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
