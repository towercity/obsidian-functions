import { promises as fsp } from "fs";
import { processNote as processNoteParent } from "./obsidian-handlers.js";

import config from "../config.js";

export function writeToAstro(note, subdir = "") {
  if (!note) {
    console.log(note);
  }
  console.log(`Writing ${note.fileName}...`);
  const processedNote = processNote(note);
  return fsp.writeFile(
    config.astroPath + "/" + subdir + processedNote.slug + ".md",
    processedNote.content,
  );
}

function processNote(note) {
  const processedNote = processNoteParent(note);
  processedNote.slug = processedNote.slug
    .replace(/[^a-zA-Z0-9]/g, "-")
    .toLowerCase();
  return processedNote;
}
