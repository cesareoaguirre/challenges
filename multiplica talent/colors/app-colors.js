// JavaScript source code
/** @cesareoaguirre
    reto: Colores
    reclutador: Multiplica Talent
*/
function AppColors() {
    console.log("AppColors")
    var currentPage = 0;
    var totalPages = 1;
    var loadingPage = null;
    var totalPages = 0;
    var currentData = {};
    let request = new XMLHttpRequest();
    let paginadorNextButtonElement = document.querySelector('.next-button');
    let paginadorPrevButtonElement = document.querySelector('.prev-button');
    let modalWrapper = document.querySelector('.modal-wrapper');
    let loadingElement = document.querySelector('.loading');

    function init() {
        paginadorNextButtonElement.onclick = function doclick() { console.log(`click next-button`); nextPage(); }
        paginadorPrevButtonElement.onclick = function doclick() { console.log(`click prev-button`); prevPage(); }
        modalWrapper.onanimationend = () => {
            console.log('animationend');
            modalWrapper.style.visibility = "hidden";
            modalWrapper.classList.remove('active-animation');
        }
        loadingElement.onanimationend = () => {
            console.log('animationend');
            loadingElement.style.visibility = "hidden";
            loadingElement.classList.remove('active-animation');
        }
        request.onload = function () {
            const response = request.response;
            console.log("total: " + response.total);
            console.log("per_page: " + response.per_page);
            console.log("page: " + response.page);
            console.log("total_pages: " + response.total_pages);
            console.log("data: " + response.data);
            totalPages = response.total_pages;
            currentData = response.data
            drawPage();
        }
        setCurrentPage(1);
    }
    /** NAVEGACI�N ENTRE P�GINAS **/
    function nextPage() {
        setCurrentPage(currentPage + 1);
    }
    function prevPage() {
        setCurrentPage(currentPage - 1);

    }
    /**
     * setCurrentPage define la p�gina a solicitar y delimita su valor
     * @param page entero
     */
    function setCurrentPage(page = 1) {
        console.log(`setCurrentPage to ${page}`);
        currentPage = Math.max(1, Math.min(page, totalPages));
        console.log(`currentPage ${currentPage}`);
        startRequest();
    }
    /** CARGA DE LOS DATOS JSON CONFORME A LA P�GINA ACTUAL */
    function startRequest() {
        console.log(`loadingPage ${loadingPage}`);

        //loadingElement.className = 'loading';
        //launchModal(loadingElement,true);

        if (loadingPage == currentPage) return;
        loadingElement.classList.toggle(`active-animation`);
        loadingElement.style.visibility = "visible";

        loadingPage = currentPage;
        let requestURL = `https://reqres.in/api/colors/?page=${currentPage}`;
        request.open('GET', requestURL);
        request.responseType = "json";
        request.send();

    }
    /**
     * drawPage dibuja los resultados
     */
    function drawPage() {
        console.log("drawPage()");
        let paginadorElement = document.querySelector('#colores-app .paginador');
        let listContainerElement = document.querySelector('#colores-app .color-list-wrapper');
        // let list = document.createElement('ul')
        let currentPageElement = document.querySelector('#colores-app .current-page');
        currentPageElement.innerHTML = `${currentPage}/${totalPages}`;
        let colorListElement = document.querySelector('#colores-app .color-list');
        colorListElement.innerHTML = "";
        console.log("paginadorElement: " + paginadorElement);
        for (var d in currentData) {
            let itemData = currentData[d];
            var itemcontents = `
<div class="color-item-def">
                        
    <div class="color-item-year"><span>${itemData.year}</span></div>
    <div>
        <div class="color-item-name"><span>${itemData.name}</span></div>
        <div class="color-item-rgb"><span>${itemData.color}</span></div>
    </div>
    <div class="color-item-pantone"><span>${itemData.pantone_value}</span></div>
</div>
                                                                 `,

                itemElement = document.createElement("li")
            colorListElement.appendChild(itemElement);
            itemElement.id = `color-item-${itemData.id}`;
            itemElement.className = "color-item";
            itemElement.style = "background-color: red;";
            itemElement.style.backgroundColor = `${itemData.color}`;
            itemElement.innerHTML = itemcontents
            itemElement.setAttribute('data-id', itemData.id);
            itemElement.onclick = function doclick() { console.log(`click`); copyColor(this.getAttribute('data-id')); }
            //console.log("item: " + itemElement.innerHTML)
        }
        listContainerElement.appendChild(colorListElement);

    }
    function copyColor(colorId) {
        console.log(`copyColor(${colorId})`);

        //document.querySelector(`#color-item-${colorId}`).cloneNode(true);
        var itemData
        for (var d in currentData) {
            itemData = currentData[d];
            if (itemData.id == colorId) break;
        }
        var itemcontents = `
                                                                    <div class="color-item-def">
                                                                        <div class="color-item-year"><span>${itemData.year}</span></div>
                                                                        <div class="color-item-copied"><span>¡Copiado!</span></div>
                                                                        <div class="color-item-pantone"><span>${itemData.pantone_value}</span></div>
                                                                    </div>
                                                                 `;
        var itemElement = document.createElement('div');
        itemElement.className = "color-item";
        itemElement.style = "background-color: red;";
        itemElement.style.backgroundColor = `${itemData.color}`;
        itemElement.innerHTML = itemcontents;
        navigator.clipboard.writeText(itemData.color).then(() => { console.log('copiado'); launchModal(itemElement); }, () => { console.log('error al copiar'); });


    }
    /**
     * Facilita la ventana modal para anunciar carga o un elemento copiado
     * @param element un elemento html a agregar
     */
    function launchModal(element, quick = 0) {
        console.log(`launchModal(quick? ${quick})`);
        modalWrapper.innerHTML = "";
        modalWrapper.appendChild(element);
        modalWrapper.classList.toggle(`active-animation`);
        modalWrapper.style.visibility = "visible";
    }
    init();
}