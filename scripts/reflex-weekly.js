import '../lib/dateExt.js';

import makeReflexNote from './reflex-generic.js';

import config from '../config.js';

// manually doing our weeks now, so as to make it easier; set the week
const firstDay = new Date(config.firstDayString);
// @var reflexLength   Set how mnany days to run the script on. Set to 7 now, 
//					   for weeklies, but change for months, etc
const reflexLength = 7;
const lastDay = new Date(config.firstDayString);
lastDay.setDate( lastDay.getDate() + reflexLength - 1);
const weekNoteTitle = config.weekliesDir + lastDay.getYYYYwWW() + '.md';

makeReflexNote(firstDay, reflexLength, weekNoteTitle);
