import jQuery from 'jquery';

jQuery(document).ready(() => {
  window.console.debug('audio-download-button-binder');

  const audios = jQuery('.js-audio-download-button-binder');

  audios.each((_i, audio) => {
    window.console.log(audio);
  });
});
