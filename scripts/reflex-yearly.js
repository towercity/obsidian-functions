import '../lib/dateExt.js';

import makeReflexNote from './reflex-generic.js';

import config from '../config.js';

//TODO: dont hardcode year
const year = 2025;

const firstDay = new Date(year, 0, 1);
const reflexLength = new Date(year, 1, 29).getMonth()==1?366:365;
const noteTitle = config.yearliesDir + year + '.md';

makeReflexNote(firstDay, reflexLength, noteTitle);
