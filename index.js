
import './lib/dateExt.js';
import { getNotes, mergeWeekContent, writeNote } from './lib/obsidian-to-astro.js';

import config from './config.js';

// manually doing our weeks now, so as to make it easier
const firstDay = new Date( "Jan 8 2024" );

const reflexLength = 7;
const datesToPull = [ ...Array(reflexLength)].map( (empty, offset) => {
  const tempDay = new Date( firstDay.toString( ));
  tempDay.setDate( tempDay.getDate() + offset )
  return tempDay
});

const filesToGather = datesToPull.map( date => {
  return config.dailiesDir + date.getYYYYMMDD() + '.md';
})

const allNotes = await getNotes(filesToGather);

const weekNoteTitle = config.weekliesDir + firstDay.getYYYYwWW() + '.md';
const weekNote = {
  fileName: weekNoteTitle,
  vaultTitle: weekNoteTitle.split('.md')[0],
  content: mergeWeekContent( allNotes )
}

console.log(weekNote)
writeNote(weekNote)
