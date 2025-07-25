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

console.log(books[0]);
