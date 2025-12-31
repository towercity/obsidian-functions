{-# LANGUAGE MultilineStrings #-}

{--
TODO:
- status to new type
- use types when possible rather than strings
--}

import notes

testNote = """
---
tags:
  - book
status: reading
rating:
aliases:
  - Structure and Interpretation of Computer Programs
  - SICP
author: "[[Harold Abelson and Gerald Jay Sussman]]"
title: Structure and Interpretation of Computer Programs
started: "[[2025-12-27]]"
cover: https://drive.konger.online/book-cover/sicp.png
---

# why i read
- gotta learn the programs!
# rev
"""




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

x = Book {
    title="Mister Sleep"
  , author="Steve King"
  , slug="mr-sleep-steve-king"
  , status="Reading"
  , cover=Just "cover.jpg"
  , review=Nothing
  , whyRead=Just "all them"
  , started=Just "[[2025-12-28]]"
  , finished=Nothing
}
