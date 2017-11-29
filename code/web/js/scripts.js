var e = 0;
var plt = 1;
var currenNeuron = [1, 1];
var W1 = [
    [0.5, 0.2, 0.3],
    [0.6, 0.5, 0.4],
    [0.7, 0.8, 0.9]
]

var W2 = [
    [0.5, 0.2, 0.3],
    [0.6, 0.5, 0.4],
    [0.7, 0.8, 0.9]
]


var A = [
    [180, 1, 1],
    [1, 180, 1],
    [1, 1, 180]
]

$(document).ready(function () {
    $('#aInput').val(A[currenNeuron[0]][currenNeuron[1]])
    plotPhaseDiagram();
    setWeights();
    $('#phase-btn').click(function () {
        plotPhaseDiagram();
        plt = 1;
    });
    $('#pattern-btn').click(function () {
        plotPattern();
        plt = 0;
    });

    var slider = document.getElementById('slider');

    noUiSlider.create(slider, {
        start: [0],
        connect: true,
        range: {
            'min': 0.00,
            'max': 1.00
        }
    });

    slider.noUiSlider.on('update', function (values, handle) {
        var value = values[handle];
        e = value;
        $('#slideVal').val(value);
        updatePlots();
    });

    $('#slideVal').change(function () {
        slider.noUiSlider.set([$(this).val(), null]);
    })

    $('.weights').change(function () {
        updateWweights();
        updatePlots();
    });

    $('.neuron').click(function () {
        var text = $(this).text();
        var n1 = text.charAt(2);
        var n2 = text.charAt(4);
        var aLabelText = text.replace("N", "A");
        $('#aLabel').text(aLabelText);
        currenNeuron[0] = n1;
        currenNeuron[1] = n2;
        $('#aInput').val(A[currenNeuron[0]][currenNeuron[1]])
        updatePlots();
    });

    $('#aInput').change(function () {
        A[currenNeuron[0]][currenNeuron[1]] = $(this).val();
        updatePlots();
    });

});

function setWeights() {
    $('#w1-1').val(W1[0][0]);
    $('#w1-2').val(W1[0][1]);
    $('#w1-3').val(W1[0][2]);
    $('#w1-4').val(W1[1][0]);
    $('#w1-5').val(W1[1][1]);
    $('#w1-6').val(W1[1][2]);
    $('#w1-7').val(W1[2][0]);
    $('#w1-8').val(W1[2][1]);
    $('#w1-9').val(W1[2][2]);

    $('#w2-1').val(W2[0][0]);
    $('#w2-2').val(W2[0][1]);
    $('#w2-3').val(W2[0][2]);
    $('#w2-4').val(W2[1][0]);
    $('#w2-5').val(W2[1][1]);
    $('#w2-6').val(W2[1][2]);
    $('#w2-7').val(W2[2][0]);
    $('#w2-8').val(W2[2][1]);
    $('#w2-9').val(W2[2][2]);
}

function updateWweights() {
    W1[0][0] = $('#w1-1').val();
    W1[0][1] = $('#w1-2').val();
    W1[0][2] = $('#w1-3').val();
    W1[1][0] = $('#w1-4').val();
    W1[1][1] = $('#w1-5').val();
    W1[1][2] = $('#w1-6').val();
    W1[2][0] = $('#w1-7').val();
    W1[2][1] = $('#w1-8').val();
    W1[2][2] = $('#w1-9').val();

    W2[0][0] = $('#w2-1').val();
    W2[0][1] = $('#w2-2').val();
    W2[0][2] = $('#w2-3').val();
    W2[1][0] = $('#w2-4').val();
    W2[1][1] = $('#w2-5').val();
    W2[1][2] = $('#w2-6').val();
    W2[2][0] = $('#w2-7').val();
    W2[2][1] = $('#w2-8').val();
    W2[2][2] = $('#w2-9').val();
}

function updatePlots() {
    if (plt == 0) {
        plotPattern();
    } else {
        plotPhaseDiagram();
    }
}

function plotPattern() {
    var pattern = getData();
    var trace1 = {
        y: pattern,
        type: 'scatter'
    };

    var data = [trace1];

    var layout = {
        title: 'Pattern on e = ' + e,
        xaxis: {
            title: 'K'
        },
        yaxis: {
            title: 'N(' + currenNeuron[0] + ', ' + currenNeuron[1] + ')'
        }
    }

    Plotly.newPlot('plot', data, layout);
}

function plotPhaseDiagram() {
    var data = getData();

    xData = data.slice(50, 250);
    yData = data.slice(49, 249);

    var trace1 = {
        x: xData,
        y: yData,
        mode: 'lines+markers'
    };

    var plotData = [trace1];
    var title = 'Neural System Response on neuron (' + currenNeuron[0] + ', ' + currenNeuron[1] + ')';
    var layout = {
        title: title,
        xaxis: {
            title: 'X(k)'
        },
        yaxis: {
            title: 'X(k-1)'
        }
    }
    var vals = xData.slice(0, 4);
    $('#val1-lbl').text('Val1: ' + vals[0].toFixed(3));
    $('#val2-lbl').text('Val1: ' + vals[1].toFixed(3));
    $('#val3-lbl').text('Val1: ' + vals[2].toFixed(3));
    $('#val4-lbl').text('Val1: ' + vals[3].toFixed(3));
    Plotly.newPlot('plot', plotData, layout);
}

function getData() {
    var sa = 0;     
    var data = [];
    for (var i = 0; i < 251; i++) {
        var result = aNSMOutup(e, sa);
        var mo = result['mo'];
        sa = result['sa'];
        data.push(mo[currenNeuron[0]][currenNeuron[1]]);
    }
    return data;
}

function multiply(a, b) {
    var c = [
        [0.5, 0.2, 0.3],
        [0.6, 0.2, 0.4],
        [0.7, 0.8, 0.9]
    ]
    for (var i in a) {
        for (var j in b) {
            c[i][j] = a[i][j] * b[i][j]
        }
    }
    return c;
}


function sum(a, b) {
    var c = [
        [0.5, 0.2, 0.3],
        [0.6, 0.2, 0.4],
        [0.7, 0.8, 0.9]
    ]
    for (var i in a) {
        for (var j in b) {
            c[i][j] = a[i][j] + b[i][j]
        }
    }
    return c;
}


function subtract(a, b) {
    var c = [
        [0.5, 0.2, 0.3],
        [0.6, 0.2, 0.4],
        [0.7, 0.8, 0.9]
    ]
    for (var i in a) {
        for (var j in b) {
            c[i][j] = a[i][j] - b[i][j]
        }
    }
    return c;
}

function mDis(val) {
    var r = [
        [0.5, 0.2, 0.3],
        [0.6, 0.2, 0.4],
        [0.7, 0.8, 0.9]
    ]
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            r[i][j] = val;
        }
    }

    return r;
}

function gauss(x, cm, l) {
    var y = Math.exp((-Math.pow((x - cm), 2) / l))
    return y;
}

function nGauss(sa) {
    l = 0.15;
    cm = 0.25;
    sa = gauss(sa, cm, l);

    return sa;
}

function matGauss(m, cm, l) {
    for (var i in m) {
        for (var j in m[i]) {
            m[i][j] = gauss(m[i][j], cm, l);
        }
    }
    return m;
}

function aNSMOutup(e, sa) {

    var E = mDis(e);
    var m1 = subtract(W1, E);

    sa = nGauss(sa);
    SA = []
    SA = mDis(sa);

    var m2 = subtract(W2, SA);
    var R = matGauss(sum(m1, m2), 0.00, 0.15);

    var result = multiply(R, A);
    return { 'mo': result, 'sa': sa };
}