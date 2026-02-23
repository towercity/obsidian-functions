{-# LANGUAGE MultilineStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module ReadNote (
  Note(..),
  readNote
) where

import Data.List
import System.FilePath (takeFileName, takeBaseName)
import NoteParser


data Note = Note {
    filename :: String
  , title :: String
  , content :: NoteContent
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
