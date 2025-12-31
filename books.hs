{--
TODO:
- status to new type
- use types when possible rather than strings
--}

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
