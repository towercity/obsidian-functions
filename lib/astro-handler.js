import { promises as fsp } from "fs";

import config from "../config.js";

export function writeToAstro( note, subdir='' ) {
    if (!note) {
        console.log(note);
      }
      console.log(`Writing ${note.fileName}...`);
      const processedNote = processNote(note);
      return fsp.writeFile(
        config.astroPath + "/" + subdir + processedNote.slug + ".md",
        processedNote.content
      );
}


function processNote( note ) {
    note.slug = note.title.replace(/\s+/g, '-').toLowerCase();

    return note;
}