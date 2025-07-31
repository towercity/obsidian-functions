/**
 * File for handling obsidian notes.
 *
 * In other words, if we're dealing with ONLY note text, we do it here. Once we get into
 * our more complex objects, uses of Astro funcs, etc, we go elsewhere.
 */
import { promises as fsp } from "fs";
import matter from "gray-matter";

import config from "../config.js";

/**
 * Splits a note into its front matter and note content
 *
 * @param {string} noteContent
 *
 * @returns {object}
 */
export function splitFrontMatter(noteContent) {
  // if we don't have frontmatter, add a dummy object
  if (noteContent.indexOf("---") !== 0) {
    return {
      frontMatter: {},
      noteContent: noteContent,
    };
  }

  const frontMatterSplitText = noteContent.split("---");
  // remove the empty first index
  frontMatterSplitText.shift();

  return {
    frontMatter: frontMatterToObject(frontMatterSplitText.shift()),
    noteContent: frontMatterSplitText.join("---"),
  };
}

/**
 * Transform a note's yaml frontmatter into a js object
 *
 * @param {string} frontmatterText  String content of frontmatter
 * @returns {object}            Object form of frontmatter
 */
export function frontMatterToObject(frontmatterText) {
  return frontmatterText.split("\n").reduce((object, line) => {
    const [key, value] = line.split(": ");
    if (key && value) {
      // some yaml strings are quoted
      if (value.trim().indexOf('"') == 0) {
        object[key.trim()] = value.trim().slice(1, -1);
      } else {
        object[key.trim()] = value.trim();
      }
    }
    return object;
  }, {});
}

export async function readNotes(subdir = "") {
  let noteFileNames = await fsp.readdir(config.vaultNotesPath + "/" + subdir);
  noteFileNames = noteFileNames.filter((fileName) => fileName.endsWith(".md"));
  let notes = await Promise.all(
    noteFileNames.map((noteFileName) => getNote(noteFileName, subdir)),
  );

  // filter out null values
  return notes.filter((note) => note);
}

/**
 * @todo
 *
 * @param {*} note
 * @returns
 */
export function processNote(note) {
  return note;
}

/**
 * Creates a note object we can use to manipulate files
 *
 * @param {string} fileName   File to pull
 * @returns {object}          Note object
 */
export async function getNote(fileName, subdir = "") {
  const noteContent = await fsp.readFile(
    config.vaultNotesPath + "/" + subdir + fileName,
    "utf-8",
  );

  const noteObj = {
    fileName,
    title: fileName.split(".md")[0],
    content: matter(noteContent).content,
  };

  if (noteContent.indexOf("---") != 0) {
    noteObj.frontMatter = {};
  } else {
    noteObj.frontMatter = matter(noteContent).data;
    // noteObj.frontMatter = frontMatterToObject(noteContent.split("---")[1]);
  }

  return noteObj;
}
