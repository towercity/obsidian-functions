{-# LANGUAGE MultilineStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}

module ReadNote (
  makeNote
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

testFileName = "/Users/j/obsidian/Writing/media/book/Harold Abelson and Gerald Jay Sussman - Structure and Interpretation of Computer Programs.md"

-- todo: handle actual reading? but how, with IO?
testRead = do
  file <- readFile testFileName
  print (makeNote testFileName file)
