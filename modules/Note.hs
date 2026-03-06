{-# LANGUAGE OverloadedRecordDot #-}
{- HLINT ignore "Replace case with maybe" -}

module Note (
    Note(..)
  , Section
  , FrontMatter
  , FrontMatterEntry
  , FrontMatterValue
  , getSection
  , getFirstAvailableSection
  , getProperty
  , getPropertyCertain
  , readNote
  , testNote
) where

import Data.Maybe (fromMaybe, listToMaybe)
import Data.List (find)
import System.FilePath (takeFileName, takeBaseName)

import Note.Parser (parseNote)
import Note.Types

-- IO
readNote :: String -> IO Note
readNote fileName = do
  file <- readFile fileName
  return (makeNote fileName file)

makeNote :: String -> String -> Note
makeNote fileName fileContents =
  Note (takeFileName fileName)
       (takeBaseName fileName)
       fm
       contents
  where
    (fm, contents) = parseNote fileContents

-- Query
getProperty :: String -> Note -> Maybe String
getProperty k note = do
  fm' <- note.fm
  value <- lookup k fm'
  listToMaybe value

getPropertyCertain :: String -> Note -> String
getPropertyCertain k = fromMaybe "" . getProperty k

getSection :: String -> Note -> Maybe String
getSection secName note = do
  section <- lookup (Just secName) (noteContent note)
  if section /= "\n" then Just section else Nothing

getFirstAvailableSection :: [String] -> Note -> Maybe String
getFirstAvailableSection secs note = foldr firstAvailableSection Nothing secs
  where
    firstAvailableSection sec acc = case getSection sec note of
      Just x  -> Just x
      Nothing -> acc

testNote = Note {filename = "Harold Abelson and Gerald Jay Sussman - Structure and Interpretation of Computer Programs.md", title = "Harold Abelson and Gerald Jay Sussman - Structure and Interpretation of Computer Programs", fm = Just [("tags",["book"]),("status",["reading"]),("rating",[""]),("aliases",["Structure and Interpretation of Computer Programs","SICP"]),("author",["\"[[Harold Abelson and Gerald Jay Sussman]]\""]),("title",["Structure and Interpretation of Computer Programs"]),("started",["\"[[2025-12-27]]\""]),("cover",["https://drive.konger.online/book-cover/sicp.png"])], noteContent = [(Nothing,"\n"),(Just "why i read","- gotta learn the programs!\n"),(Just "rev","\n")]}
