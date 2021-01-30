import jQuery from 'jquery';
import download from 'downloadjs';

function audioDownload(manager, id, format) {
  window.console.debug(`AJAX ${format}: ${manager}#${id}`);

  return new Promise((resolve, reject) => {
    jQuery.ajax({
      type: 'GET',
      url: 'audio',
      data: { audio: { manager, id, format } },
      xhrFields: { responseType: 'blob' },
      success: (data, textStatus, jqXHR) => { resolve({ data, textStatus, jqXHR }); },
      error: reject,
    });
  });
}

function audioButtonLoaderEnable($button) {
  $button.html('<i class="fa fa-spinner" aria-hidden="true"></i>');
  $button.prop('disabled', true);
  $button.children().first().addClass('spinning');
}

function audioButtonLoaderDisable($button, oldHtml) {
  $button.html(oldHtml);
  $button.prop('disabled', false);
}

function audioButtonClick() {
  const $button = jQuery(this);
  if ($button.prop('disabled')) return;

  const audioName = $button.closest('li').children().first().text();

  const { manager, id } = $button.data();
  const format = jQuery('.js-audio-download-format').val() || 'm3u8';

  const oldHtml = $button.html();
  audioButtonLoaderEnable($button);

  audioDownload(manager, id, format).then(({ data, jqXHR }) => {
    const name = `${audioName}.${format}`;
    const type = jqXHR.getResponseHeader('content-type');

    window.console.debug(`Downloading ${name}, type: ${type}`);
    download(data, name, type);

    audioButtonLoaderDisable($button, oldHtml);
  }, () => {
    audioButtonLoaderDisable($button, oldHtml);
  });
}

jQuery(document).ready(() => {
  window.console.debug('Fired audio-download-button-binder');

  const buttons = jQuery('.js-audio-download-button-binder');

  buttons.each((_i, audio) => {
    jQuery(audio).on('click', audioButtonClick);
  });
});
