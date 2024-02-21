/**
 * Take in the string representation of a note's content (without its front
 * matter) and converts it into an object representation
 * 
 * @param {string} noteContent  
 * 
 * @returns {object}
 */
export function convertNoteContentToObject(noteContent) {
    const noteBySections = splitNoteContentBySection(noteContent);


    return noteBySections.map(splitSectionIntoObject);
}


/**
 * Spilts the note content into multiple notes by level 1 heading
 * 
 * @param {string} noteContent 
 * 
 * @returns {object[]}  Array of section contents and titles in the following
 *                      object format: {
 *                          'sectionTitle': 'title',
 *                          'content': 'content'
 *                      }
 */
function splitNoteContentBySection(noteContent) {
    // split the object by top level headings, which will always start a line 
    // and end in a space
    return noteContent.split('\n# ')
        // get rid of any content before our first heading
        .slice(1)
        // create objects out of each section now
        .map(section => {
            // make sure we have content; if not, return an empty representation.
            // lucky for us, we know from markdown structure that headings MUST
            // be followed by a linebreak in order to have child content
            if (!section.includes('\n')) {
                return {
                    // our section is, by definition, only title
                    'sectionTitle': section,
                    'content': ''
                }
            }

            // since we've got this far, we know we have content. our first line
            // WILL be our section title. let's use this (as well as a bit of
            // `split()`) to our advantage
            const sectionAsArray = section.split('\n');
            return {
                // pulls out and uses our first element, which MUST be title
                'sectionTitle': sectionAsArray.shift(),
                // then we just join back up the rest!
                'content': sectionAsArray.join('\n')
            }
        })
}


/**
 * 
 * @param {object} sectionObject    Object as made in `convertNoteContentToObject`
 * 
 * @returns {object}    Object of list items with in following format: {
 *                          'sectionTitle': 'title',
 *                          'content': [
 *                              {
 *                                  'slug': '[[slug]],
 *                                  'content': [
 *                                      'contenString'
 *                                  ]
 *                              },
 *                          ]
 *                      }
 */
function splitSectionIntoObject(sectionObject) {
    return sectionObject.content
        // flatten all sublists, as they get to messy for our purposes now
        .replaceAll(/[:]?\n\t-/g, ',')
        // remove all todos with a regex
        .replaceAll(/\[[x ]\] /g, '')
        // split the content into an array by line breaks
        .split('\n')
        // remove empty lines
        .filter(line => '' !== line)
        // transform to object
        .map(lineContent => {
            const lineContentAsArray = lineContent.split(': ');
            return {
                'slug': lineContentAsArray.shift()
                    // clear out line start
                    .replace(/^- /, ''),
                'content': [
                    lineContentAsArray.join(': ')
                ]
            }
        });
}