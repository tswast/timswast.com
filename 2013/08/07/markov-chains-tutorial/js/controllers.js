function MarkovCtrl($scope) {
    
    $scope.transitionMatrix = [
        {color:"#054321", transitions:[{value:990}, {value:10}, {value:0}, {value:0}, {value:0}]},
        {color:"#000000", transitions:[{value:10}, {value:980}, {value:10}, {value:0}, {value:0}]},
        {color:"#6400C8", transitions:[{value:10}, {value:0}, {value:990}, {value:0}, {value:0}]},
        {color:"#C80064", transitions:[{value:0}, {value:0}, {value:0}, {value:0}, {value:0}]},
        {color:"#FA9600", transitions:[{value:0}, {value:0}, {value:0}, {value:0}, {value:0}]}
    ];
    
    $scope.initialState = 1;
    
    $scope.reset = function() {
        // Setup the Markov chain.
        transitionMatrix = [];
        for (var rowi in $scope.transitionMatrix) {
            var row = $scope.transitionMatrix[rowi];
            colors[rowi] = row.color;
            
            var nrow = [];
            for (var coli in row.transitions) {
                nrow.push(row.transitions[coli].value / 1000.0);
            }
            
            transitionMatrix.push(nrow);
        }
        currentstate = $scope.initialState - 1;
        
        // Reset the canvas.
        var canvas = document.getElementById('tutorial');
        var ctx = canvas.getContext('2d');
        ctx.clearRect (0, 0, 512, 512);
        currentstep = 0;
        window.requestAnimFrame(step);
    };
    
    // Make sure the initial state matches what is displayed.
    // Angular.js will not call the controller until the page has
    // loaded, so this is safe to call.
    $scope.reset();
}
