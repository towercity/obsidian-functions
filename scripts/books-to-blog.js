/**
 * What we need to do:
 * 1. pull in books from the book directory
 * 2. parse the metadata from the book files
 * 3. make sure each file IS a book, so i guess "validation"
 * 4. generate json for the books, from the structured way i write them
 * 5. save the json to the astro directory
 */
import { promises as fsp } from "fs";

import config from "../config.js";
import { readNotes } from "../lib/obsidian-handlers.js";

const convertBookNoteToObject = (bookNote) => {
  const { frontMatter } = bookNote;
  const { title, started, finished, publish, status, cover } = frontMatter;
  // TODO: add function to get years touched
  // TODO handle multiple start/ends
  // TODO: get dates from why i read etcs

  const {
    content,
    rev: review,
    ["why i read"]: whyRead,
    ["why i gave up"]: gaveUp,
  } = splitByHeadings(bookNote.content);

  const book = {
    title,
    author: getAuthor(frontMatter),
    started,
    finished,
    publish,
    status,
    cover,
    content,
    review,
    whyRead,
    gaveUp,
  };

  // return bookNote;
  return book;
};

const getAuthor = (frontMatter) => {
  const author = frontMatter.author;
  if (!author) return "";
  if ("string" === typeof author) {
    return convertObsidianLink(author);
  }
  return convertObsidianLink(author.join(", "));
};

// remove links, for now
const convertObsidianLink = (text) => {
  return text.replace(/\[\[(.*?)\]\]/g, "$1");
};

const splitByHeadings = (content) => {
  const labeledSections = {};
  content.split("\n# ").forEach((section, idx) => {
    section = section.trim("\n");

    if (0 === idx) {
      labeledSections["content"] = section;
    }

    const [title, ...lines] = section.split("\n");
    labeledSections[title] = lines.length > 0 ? lines.join("\n") : "";
  });

  return labeledSections;
};

const booksNotes = await readNotes(config.booksDir);
const books = booksNotes.map(convertBookNoteToObject);

// console.log(books[0]);
// TODO: save a json to the astro :)
console.log(config.astroPath + "data/books.json");
fsp.appendFile(config.astroPath + "data/books.json", JSON.stringify(books));
