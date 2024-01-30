import './lib/dateExt.js';
import { getNotes, mergeWeekContent, writeNote } from
  './lib/obsidian-to-astro.js';

import config from './config.js';

// manually doing our weeks now, so as to make it easier; set the week
const firstDay = new Date("Jan 22 2024");

// @var reflexLength   Set how mnany days to run the script on. Set to 7 now, 
//					   for weeklies, but change for months, etc
const reflexLength = 7;

// Dynamically create an array of dates `reflexLength` long starting from 
// `firstDay`
const datesToPull = [...Array(reflexLength)].map((empty, offset) => {
  const tempDay = new Date(firstDay.toString());
  tempDay.setDate(tempDay.getDate() + offset)
  return tempDay
});

// Create a list of obsidian file names from the above `datesToPull` array
const filesToGather = datesToPull.map(date => {
  return config.dailiesDir + date.getYYYYMMDD() + '.md';
})

// @var allNotes    All the notes we're pulling from, called from external func
const allNotes = await getNotes(filesToGather);

const weekNoteTitle = config.weekliesDir + firstDay.getYYYYwWW() + '-generated.md';
const weekNote = {
  fileName: weekNoteTitle,
  vaultTitle: weekNoteTitle.split('.md')[0],
  content: mergeWeekContent(allNotes)
}

console.log(weekNote)
writeNote(weekNote)
