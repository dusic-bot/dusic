import jQuery from 'jquery';

function headCellClick(event) {
  const index = event.data.headCells.indexOf(this);

  window.console.debug(`Sorting table by column#${index}`);

  // TODO
}

function bind(table) {
  const $table = jQuery(table);

  const $headCells = $table.find('thead td:not([colspan])');
  $headCells.on('click', { table, headCells: $headCells.toArray() }, headCellClick);
}

jQuery(() => {
  window.console.debug('Fired tale-sorter-binder');

  const tables = jQuery('.js-table-sorter-binder');

  tables.each((_i, table) => {
    bind(table);
  });
});
