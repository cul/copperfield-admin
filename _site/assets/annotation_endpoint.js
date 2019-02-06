// ON LOAD


$(document).ready(function() {
  $('#no_anno_button').click(function() {
    $("#anno_results").empty();
  });

  $('#no_gui_button').click(function() {
    $("#gui_results").empty();
  });

  $('#anno_button').click(function() {
    var sumAnnotations = getLocalAnnotations();

    $('#anno_results').empty();
    $('#anno_results').append(`<div class='anno'><h3>Results (JSON): ${sumAnnotations.length} locally generated annotations were found</h3><textarea rows='30' cols='100' id='annotationJSON'>${JSON.stringify(sumAnnotations, null, 2)}</textarea></div>`);
  });


  $('#gui_button').click(function() {
    var sumAnnotations = getLocalAnnotations();
    $("#gui_results").empty();
    $('#gui_results').append(`<div class='anno'><h3>Results (GUI):</h3><ul id='annotationGUI'></ul></div>`)
    for (a in sumAnnotations) {
      $('#annotationGUI').append(`<li>${annotationToText(sumAnnotations[a])}</li>`);
    };

    $('.annotation_link').click(function() {
      var canvas = $(this).attr('canvas');
      var manifest = $(this).attr('manifest');

      turnPageTo(canvas, manifest);
    });
  });


  $("#download").click(function() {
    var d = new Date();
    var datetime = `${d.getFullYear()}-${d.getMonth()+1}-${d.getDate()}_${d.getHours()}-${d.getMinutes()}-${d.getSeconds()}`;
    var filename = `annotations_${datetime}.json`

    download(filename, $('#annotationJSON').val());
  });
});





// FUNCTIONS




function turnPageTo(canvas, manifest) {
  console.log(window.viewer.canvasID);
  window.viewer.canvasID = canvas;
};

function annotationToText(anno) {
  var text = [];
  var canvas = anno['on'][0]['full'];
  var canvas_name = canvas.split('/').slice(-1).pop();
  var manifest = anno['on'][0]['within']['@id'];

  console.log(anno);

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

function createZenViewer(manifests) {
  opts = {
    id: 'mirador-iiif-viewer',
    data: [],
    windowObjects: [{
      loadedManifest: manifests[0],
      displayLayout: false,
      bottomPanel: false,
      sidePanel: false,
      annotationLayer: true
    }],
    mainMenuSettings: {
      show: false
    }
  };
  for (m in manifests) {
    opts.data.push({ 'manifestUri': manifests[m] });
  }
  return Mirador(opts);
}

function createAnnotationAdminViewer(manifests) {
  opts = {
    id: 'mirador-iiif-viewer',
    annotationEndpoint: {
      name: 'Local Storage',
      module: 'LocalStorageEndpoint'
    },
    data: [],
    windowObjects: [{
      loadedManifest: manifests[0],
      displayLayout: false,
      bottomPanel: false,
      sidePanel: false,

    }]
  };
  for (m in manifests) {
    opts.data.push({ 'manifestUri': manifests[m] });
  }
  return Mirador(opts);
}

function addManifestAsWindowedObject(viewer, manifest) {
 viewer.viewer.state.currentConfig.windowObjects = [{'loadedManifest': manifest }];
}

function addManifestsToViewer(viewer, manifests) {
  addManifestAsWindowedObject(manifests[0]);
  for (m in manifests) {
    viewer.viewer.data.push({ 'manifestUri': manifests[m] });
  }
}
