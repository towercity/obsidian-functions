import { promises as fsp } from "fs";

import config from "../config.js";


export async function getNote(fileName) {
  const noteContent = await fsp.readFile(
    config.vaultNotesPath + "/" + fileName,
    "utf-8"
  );

  const splitContent = noteContent.split('# ');
  const noteSections = {};
  config.sectionsToPull.forEach( sectionName => {
    noteSections[ sectionName ] = 
      splitContent.find( section => section.startsWith( sectionName ) )
                  .replace( `${sectionName}\n`, '' )
  })
  
  return {
    fileName,
    vaultTitle: fileName.split(".md")[0],
    content: noteContent,
    sections: sortNoteSections( noteSections )
  };
}

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

function sortNoteSections(sectionObject) {
  for ( const section in sectionObject ) {
    sectionObject[section] = sortNoteSection( sectionObject[section] );
  }
  return sectionObject;
}

function sortNoteSection( section ) {
  return section.split('\n').sort().join('\n');
}

export async function getNotes( fileNames ) {
  return Promise.all(fileNames.map( async (fileName) => {
    return await getNote( fileName )
  }))
}

export function mergeWeekContent( notesObject ) {
  const mergedWeekContent = {}
  for (const section in notesObject[0].sections ) {
    mergedWeekContent[ section ] = [];
  }
  
  const reducedWeeks = notesObject.reduce( (prev, curr) => {
    const sections = curr.sections
    for (const section in sections) {
      prev[section].push( ...sections[section].split('\n').filter(n => n) );
    }
    return prev;
  }, mergedWeekContent)

  let returnString = '';
  for (const section in reducedWeeks) {
    const sectionContent = reducedWeeks[ section ].sort().join('\n');
    returnString += `# ${section}\n${sectionContent}\n\n`;
  }
  
  return returnString;
}

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
function processNote( note ) {
  return note;
}