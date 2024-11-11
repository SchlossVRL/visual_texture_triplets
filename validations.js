const xlsx = require('xlsx');
const fs = require('fs');

// Read the Excel file
const workbook = xlsx.readFile('/Users/annachinni/Dropbox/TextureSemantics/VisualTextureTriplets/Triplet Code/Triplet Experiment/Triplet Data Cleaning and Setup/validation_comparisons.xlsx');
// Specify the sheet name you want to read
const sheetName = 'Randomized Sets'; 
const sheet = workbook.Sheets[sheetName];

// Convert the sheet to JSON
const data = xlsx.utils.sheet_to_json(sheet);

// Create the desired structure
const result = data.map(row => ({
    head: row.head,
    choice_1: row.choice_1,
    choice_2: row.choice_2
}));

// Specify the name of the JSON file
const jsonFileName = 'validations.json';

// Custom stringify function to format the JSON as desired
const customStringify = (obj) => {
    return obj.map(item => {
        return `{
    head: '${item.head}',
    choice_1: '${item.choice_1}',
    choice_2: '${item.choice_2}'
  }`;
    }).join(',\n');
};

// Save the result to a JSON file
fs.writeFileSync(jsonFileName, `[${customStringify(result)}]`);

console.log(`Data has been written to ${jsonFileName}`);