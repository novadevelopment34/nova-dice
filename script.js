let cube = document.getElementById('cube');
let container = document.getElementById('dice-container');
let hint = document.querySelector('.hint-text');
let clickArea = document.getElementById('click-area');


const rotations = {
    1: 'rotateY(0deg)',
    2: 'rotateY(-90deg)',
    3: 'rotateY(-180deg)',
    4: 'rotateY(90deg)',
    5: 'rotateX(-90deg)',
    6: 'rotateX(90deg)'
};

window.addEventListener('message', function(event) {
    let data = event.data;

    if (data.action === "openPlaceholder") {

        resetDice();
        container.style.display = 'flex';
        clickArea.style.pointerEvents = 'auto';
        hint.style.display = 'block';
    } 
    else if (data.action === "rollAnimation") {

        startRolling(data.result);
    }
});

function requestRoll() {
    clickArea.style.pointerEvents = 'none'; 
    hint.style.display = 'none';
    
    fetch(`https://${GetParentResourceName()}/startRoll`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({})
    });
}

function startRolling(result) {
    container.style.display = 'flex';
    hint.style.display = 'none';
    clickArea.style.pointerEvents = 'none'; 

    cube.style.transition = 'none';
    cube.classList.add('is-spinning');


    setTimeout(() => {
        cube.classList.remove('is-spinning');
        cube.style.transition = 'transform 1.5s cubic-bezier(0.2, 0.8, 0.2, 1)';
        

        let xExtra = 720; 
        let yExtra = 720;
        

        cube.style.transform = `translateZ(-50px) ${rotations[result]}`;
        
    }, 600); 


    setTimeout(() => {
        container.style.display = 'none';
        

        fetch(`https://${GetParentResourceName()}/animFinished`, { method: 'POST' });
        
    }, 4000); 
}

function resetDice() {
    cube.style.transition = 'none';
    cube.style.transform = 'translateZ(-50px) rotateX(0deg) rotateY(0deg)';
}