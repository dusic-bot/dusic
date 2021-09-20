import jQuery from 'jquery';

const HEAD_CELLS_CSS_SELECTOR = 'thead td:not([colspan])';

function parseCellValue(cell) {
  return cell.innerText;
}

function IsEqualHTMLCollection(collectionA, collectionB) {
  if (collectionA.length !== collectionB.length) return false;

  for (let index = 0; index < collectionA.length; index += 1) {
    if (collectionA[index] !== collectionB[index]) return false;
  }

  return true;
}

function spaceshipCompare(a, b) {
  if (a === b) {
    return 0;
  }

  if (a < b) {
    return -1;
  }

  return 1;
}

function sortLines(lines, index, invert = false) {
  return lines.sort((lineA, lineB) => {
    const cellA = jQuery(lineA).find('td').toArray()[index];
    const cellB = jQuery(lineB).find('td').toArray()[index];

    let cellValueA = parseCellValue(cellA);
    let cellValueB = parseCellValue(cellB);

    if (invert) {
      [cellValueA, cellValueB] = [cellValueB, cellValueA];
    }

    return spaceshipCompare(cellValueA, cellValueB);
  });
}

function headCellClick() {
  const $table = jQuery(this).closest('table');
  const $headCells = $table.find(HEAD_CELLS_CSS_SELECTOR);

  const index = $headCells.toArray().indexOf(this);

  window.console.debug(`Sorting table by column#${index}`);
  const lines = $table.find('tbody tr').toArray();
  const sortedLines = sortLines([...lines], index);

  if (IsEqualHTMLCollection(sortedLines, lines)) {
    sortedLines.reverse();
  }

  lines.forEach((line, lineIndex) => {
    line.parentElement.appendChild(sortedLines[lineIndex]);
  });
}

function bind(table) {
  const $table = jQuery(table);

  $table.find(HEAD_CELLS_CSS_SELECTOR).on('click', headCellClick);
}

jQuery(() => {
  window.console.debug('Fired tale-sorter-binder');

  const tables = jQuery('.js-table-sorter-binder');

  tables.each((_i, table) => { bind(table); });
});
