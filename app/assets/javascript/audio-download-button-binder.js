import jQuery from 'jquery';
import { sleep } from 'javascript/sleep';

function audioDownload(manager, id, format) {
  window.console.debug(`AJAX ${format}: ${manager}#${id}`);

  return new Promise(function(resolve, reject) {
    jQuery.ajax({
      type: 'GET',
      url: 'audio',
      data: { audio: { manager, id, format } },
      xhrFields: { responseType: 'blob' },
      success: (data, textStatus, jqXHR) => { resolve({ data, textStatus, jqXHR }); },
      error: reject
    });
  });
}

function audioButtonClick() {
  const $button = jQuery(this);
  if ($button.prop('disabled')) return;

  const audio_name = $button.closest('li').children().first().text();

  const { manager, id } = $button.data();
  const format = jQuery('.js-audio-download-format').val() || 'm3u8';

  const oldHtml = $button.html();
  $button.html('<i class="fa fa-spinner" aria-hidden="true"></i>');
  $button.prop('disabled', true);
  $button.children().first().addClass('spinning');

  audioDownload(manager, id, format).then(({ raw_data, jqXHR }) => {
    const name = `${audio_name}.${format}`;
    const type = jqXHR.getResponseHeader('content-type');

    window.console.debug(`Downloading ${name}, type: ${type}`);

    download(raw_data, name, type);

    $button.html(oldHtml);
    $button.prop('disabled', false);
  }, console.error);
}

jQuery(document).ready(() => {
  window.console.debug('Fired audio-download-button-binder');

  const buttons = jQuery('.js-audio-download-button-binder');

  buttons.each((_i, audio) => {
    jQuery(audio).on('click', audioButtonClick);
  });
});
