import jQuery from 'jquery';
import { sleep } from 'javascript/sleep';

function audioDownload(manager, id, format) {
  window.console.debug(`Loading ${format}: ${manager}#${id}`);
  // TODO
  return sleep(5000);
}

function audioButtonClick() {
  const $button = jQuery(this);
  if ($button.prop('disabled')) return;

  const { manager, id } = $button.data();
  const format = 'm3u8'; // TODO: set via interface

  const oldHtml = $button.html();
  $button.html('<i class="fa fa-spinner" aria-hidden="true"></i>');
  $button.prop('disabled', true);
  $button.children().first().addClass('spinning');

  audioDownload(manager, id, format).then(() => {
    $button.html(oldHtml);
    $button.prop('disabled', false);
  });
}

jQuery(document).ready(() => {
  window.console.debug('Fired audio-download-button-binder');

  const buttons = jQuery('.js-audio-download-button-binder');

  buttons.each((_i, audio) => {
    jQuery(audio).on('click', audioButtonClick);
  });
});
