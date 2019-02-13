// ON LOAD


$(document).ready(function() {
  $('.manifest_selector').click(function() {
    var manifest = $(this).attr('manifest');
    document.getElementById('mirador-iiif-viewer').innerHTML = '';
    createAnnotationAdminViewer(window.data, manifest=manifest);
  });

  $('#hide').click(function() {
    $("#gui_results").empty();
    $("#anno_results").empty();
  });

  $('#view').click(function() {
    var sumAnnotations = getLocalAnnotations();

    $('#anno_results').empty();
    $("#gui_results").empty();

    $('#anno_results').append(`<div class='anno'><h2>JSON</h2><textarea rows='30' cols='100' id='annotationJSON'>${JSON.stringify(sumAnnotations, null, 2)}</textarea></div>`);


    $('#gui_results').append(`<div class='anno'><h2>Results</h2><ul id='annotationGUI'></ul></div>`)
    for (a in sumAnnotations) {
      $('#annotationGUI').append(`<li>${annotationToText(sumAnnotations[a])}</li>`);
    };

    $('.annotation_link').click(function() {
      var canvas = $(this).attr('canvas');
      var manifest = $(this).attr('manifest');

      let mirador = window.viewer;
      let miradorWindow = mirador.viewer.workspace.windows[0];
      let event = 'SET_CURRENT_CANVAS_ID.' + miradorWindow.id;
      let canvasID = canvas;
      mirador.eventEmitter.publish(
        event, canvas
      );
    });
  });

  $("#download").click(function() {
    var d         = new Date();
    var datetime  = `${d.getFullYear()}-${zPad(d.getMonth()+1)}-${zPad(d.getDate())}_${zPad(d.getHours())}-${zPad(d.getMinutes())}-${zPad(d.getSeconds())}`;
    var filename  = `annotations_${datetime}.json`
    var json      = JSON.stringify(getLocalAnnotations(), null, 2);

    download(filename, json);
  });
});





// FUNCTIONS

function zPad(num) {
  return String(num).padStart(2, '0');
}

function annotationToText(anno) {
  var text = [];
  var canvas = anno['on'][0]['full'];
  var canvas_name = canvas.split('/').slice(-1).pop();
  var manifest = anno['on'][0]['within']['@id'];

  for (r in anno['resource']) {
    var resource = anno['resource'][r];
    if (resource['@type'] == 'dctypes:Text') {
      text.push(resource['chars'].replace(/(<([^>]+)>)/ig, ''));
    }
  }

  text = text.join(', ');
  if(text.length > 50) {
    text = `${text.substring(0,49)}...`;
  }

  return `<b>"${text}"</b> on canvas <a href='#${canvas_name}' canvas='${canvas}' manifest='${manifest}' class='annotation_link'>#${canvas_name}</a>`;
}




function getLocalAnnotations() {
  var keys            = Object.keys(localStorage);
  var canvases        = keys.filter(function(k){ return k.startsWith('http'); });
  var sumAnnotations  = [];

  for (c in canvases) {
    var annotations = JSON.parse(localStorage[canvases[c]]);
    for (i in annotations) {
      sumAnnotations.push(annotations[i]);
    }
  }

  return sumAnnotations;
}

function download(filename, text) {
  var element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
  element.setAttribute('download', filename);
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
}

function createAnnotationAdminViewer(data, manifest=null, canvas=null) {
  window.data = data;
  opts = {
    id: 'mirador-iiif-viewer',
    annotationEndpoint: {
      name: 'Local Storage',
      module: 'LocalStorageEndpoint'
    },
    data: [],
    windowObjects: [{
      loadedManifest: manifest || data[0],
      displayLayout: false,
      sidePanel: false,

    }]
  };

  if (canvas != null) { opts.windowObjects[0].canvasID = canvas; }
  for (d in data) { opts.data.push({ 'manifestUri': data[d] }); }
  return Mirador(opts);
}
