import jQuery from 'jquery';

function audioButtonClick() {
  const $button = jQuery(this);
  const { manager, id } = $button.data();

  window.console.debug(`${manager}: ${id}`);

  // const oldHtml = $button.html();
  $button.html('<i class="fa fa-spinner" aria-hidden="true"></i>');
  $button.prop('disabled', true);
  $button.children().first().addClass('spinning');
}

jQuery(document).ready(() => {
  window.console.debug('audio-download-button-binder');

  const buttons = jQuery('.js-audio-download-button-binder');

  buttons.each((_i, audio) => {
    jQuery(audio).on('click', audioButtonClick);
  });
});
