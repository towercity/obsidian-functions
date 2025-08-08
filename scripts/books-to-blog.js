/**
 * What we need to do:
 * 1. pull in books from the book directory
 * 2. parse the metadata from the book files
 * 3. make sure each file IS a book, so i guess "validation"
 * 4. generate a post for each book, from the structured way i write them
 * 5. save the post to the astro directory
 */

import config from "../config.js";
import { readNotes } from "../lib/obsidian-handlers.js";

let books = await readNotes(config.booksDir);

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
  if ("string" === typeof author) {
    return convertObsidianLink(author);
  }
  return author.join(", ");
};

// empty, for now
const convertObsidianLink = (text) => {
  return text;
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

console.log(convertBookNoteToObject(books[0]));
