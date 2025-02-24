import '../lib/dateExt.js';
import { getNotes, mergeReflexNoteContent, appendNote } from
    '../lib/obsidian-to-astro.js';

import config from '../config.js';


export default async function makeReflexNote(firstDay, reflexLength, noteTitle) {
    // Dynamically create an array of dates `reflexLength` long starting from 
    // `firstDay`
    const datesToPull = [...Array(reflexLength)].map((empty, offset) => {
        const tempDay = new Date(firstDay.toString());
        tempDay.setDate(tempDay.getDate() + offset);
        return tempDay;
    });

    // Create a list of obsidian file names from the above `datesToPull` array
    const filesToGather = datesToPull.map(date => {
        return config.dailiesDir + date.getYYYYMMDD() + '.md';
    });

    // @var allNotes    All the notes we're pulling from, called from external func
    const allNotes = await getNotes(filesToGather);

    const generatedNote = {
        fileName: noteTitle,
        vaultTitle: noteTitle.split('.md')[0],
        content: mergeReflexNoteContent(allNotes)
    }

    // console.log(generatedNote);
    appendNote(generatedNote);
}