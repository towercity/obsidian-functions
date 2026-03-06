{-# LANGUAGE MultilineStrings #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedRecordDot #-}

module MakeBook (
  Book(..),
  makeBook
) where

import Data.Maybe (fromMaybe, listToMaybe)
import Data.Char (toLower)
import Data.List (find)
import Control.Monad (guard)

import ReadNote

data Book = Book {
    title :: String
  , author :: String
  , slug :: String
  , status :: String
  , cover :: Maybe String
  , review :: Maybe String
  , whyRead :: Maybe String
  , started :: Maybe String
  , finished :: Maybe String
} deriving (Show)

testFileName = "/Users/j/obsidian/Writing/media/book/Harold Abelson and Gerald Jay Sussman - Structure and Interpretation of Computer Programs.md"

makeBook :: Note -> Book
makeBook note =
  Book (getPropertyCertain "title" note)
       (getPropertyCertain "author" note)
       (makeSlug note.title)
       (getPropertyCertain "status" note)
       (getProperty "cover" note)
       (getReview note)
       (getSection "Why I Read" note)
       (getProperty "started" note)
       (getProperty "finished" note)

getPropertyCertain :: String -> Note -> String
getPropertyCertain k = fromMaybe "" . getProperty k

getProperty :: String -> Note -> Maybe String
getProperty k note = do
  fm' <- note.fm
  value <- lookup k fm'
  listToMaybe value

makeSlug :: String -> String
makeSlug = map (unSpace . toLower)
  where
    unSpace ' ' = '-'
    unSpace  c  =  c

getSection :: String -> Note -> Maybe String
getSection secName note = do
  section <- lookup (Just secName) (noteContent note)
  guard (section /= "\n")
  return section

getFirstAvailableSection :: [String] -> Note -> Maybe String
getFirstAvailableSection secs note = foldr firstAvailableSection Nothing secs
  where
    firstAvailableSection sec acc = case getSection sec note of
      Just x  -> Just x
      Nothing -> acc

getReview :: Note -> Maybe String
getReview = getFirstAvailableSection ["why i gave up", "rev"]
