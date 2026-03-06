{-# LANGUAGE OverloadedRecordDot #-}

module Book (
    Book(..)
  , makeBook
) where

import Data.Maybe (fromMaybe)
import Data.Char (toLower)

import Note

data Book = Book {
    title    :: String
  , author   :: String
  , slug     :: String
  , status   :: String
  , cover    :: Maybe String
  , review   :: Maybe String
  , whyRead  :: Maybe String
  , started  :: Maybe String
  , finished :: Maybe String
} deriving (Show)

makeBook :: Note -> Book
makeBook note =
  Book (getPropertyCertain "title"  note)
       (getPropertyCertain "author" note)
       (makeSlug note.title)
       (getPropertyCertain "status" note)
       (getProperty "cover"    note)
       (getReview             note)
       (getSection "why i read" note)
       (getProperty "started"  note)
       (getProperty "finished" note)

makeSlug :: String -> String
makeSlug = map (unSpace . toLower)
  where
    unSpace ' ' = '-'
    unSpace  c  =  c

getReview :: Note -> Maybe String
getReview = getFirstAvailableSection ["why i gave up", "rev"]
