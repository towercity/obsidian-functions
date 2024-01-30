import { promises as fsp } from "fs";

import config from "../config.js";



/**
 * Creates a note object we can use to manipulate files
 * 
 * @param {string} fileName   File to pull
 * @returns {object}          Note object
 */
export async function getNote(fileName) {
  const noteContent = await fsp.readFile(
    config.vaultNotesPath + "/" + fileName,
    "utf-8"
  );

  const splitContent = noteContent.split('# ');
  const noteSections = {};
  config.sectionsToPull.forEach(sectionName => {
    const sectionContent = splitContent.find(section => section.startsWith(sectionName))

    // failsafe: makes sure to fail gracefully if we don't have a named section in a note
    if (sectionContent) {
      noteSections[sectionName] = sectionContent.replace(`${sectionName}\n`, '');
    }
  })

  return {
    fileName,
    vaultTitle: fileName.split(".md")[0],
    content: noteContent,
    sections: sortNoteSections(noteSections)
  };
}

/**
 * Transform a note's yaml frontmatter into a js object
 * 
 * @param {string} noteContent  String content of note
 * @returns {object}            Object form of frontmatter
 */
export function frontMatterToObject(noteContent) {
  if (noteContent.indexOf("---") != 0) return null;

  const frontmatterText = noteContent.split("---")[1];
  // convert frontmatter to object

  return frontmatterText.split("\n").reduce((object, line) => {
    const [key, value] = line.split(":");
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

/**
 * Sorts all the sections in a note. See more details in `sortNoteSection`
 * 
 * @param {object} sectionObject  An object of named note sections
 * @returns {object}              This same object, with its children sorted
 */
function sortNoteSections(sectionObject) {
  for (const section in sectionObject) {
    sectionObject[section] = sortNoteSection(sectionObject[section]);
  }
  return sectionObject;
}

/**
 * Takes in a section in one of our daily notes and sorts it alphabetically.
 * 
 * Assumes that we're working with an unordered list
 * 
 * @param {string} section  Content of the section
 * @returns {string}        The content, alphabetized
 */
function sortNoteSection(section) {
  return section.split('\n').sort().join('\n');
}

/**
 * Gather in all the notes in an array of file names
 * 
 * @param {arary} fileNames Notes to open
 * @returns {array}         An array of note objects
 */
export async function getNotes(fileNames) {
  return Promise.all(fileNames.map(async (fileName) => {
    return await getNote(fileName)
  }))
}

/**
 * Merges all the content of a list of notes into one long note, by titled 
 * section
 * 
 * @todo Generecize away from weeks
 * 
 * @param {array} notesObject Array of notes to merge
 * @returns {string}          The note content of the new, merged note
 */
export function mergeWeekContent(notesObject) {
  // merge the sections together
  const reducedWeeks = notesObject.reduce((prev, curr) => {
    const sections = curr.sections
    for (const section in sections) {
      // make sure we have our sections
      if (!prev[section]) {
        prev[section] = [];
      }

      prev[section].push(...sections[section].split('\n').filter(n => n));
    }
    return prev;
  }, {})

  // make our sections into one long string
  let returnString = '';
  for (const section in reducedWeeks) {
    const sectionContent = reducedWeeks[section].sort().join('\n');
    returnString += `# ${section}\n${sectionContent}\n\n`;
  }

  return returnString;
}

/**
 * Save a note object to disk
 * 
 * @param {object} note   Our note, expressed as an object
 */
export function writeNote(note) {
  if (!note) {
    console.log(note);
  }
  console.log(`Writing ${note.fileName}...`);
  note = processNote(note);
  return fsp.writeFile(
    config.vaultNotesPath + "/" + note.fileName,
    note.content
  );
}

// @TODO
// atm does nothing
function processNote(note) {
  return note;
}
