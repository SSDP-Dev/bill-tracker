
function loadCollection(id) {
    console.log(id);
    fetch('/api/collection/' + id)
        .then(function (response) {
            return response.json();
        })
        .then(function (collection){
            viewCollection(collection.collection_hash);
        });
}

function viewCollection(collection) {
    console.log(collection);
    Object.keys(collection).map(function (objectKey, index) {
        var value = collection[objectKey];
        console.log(value);
        id = value["id"];
        title = value["title"];
        identifier = value["identifier"];
        state = value["state"];
        session = value["session"];
        console.log(id + title + identifier + state + session);
        // Find a <table> element with id="myTable":
        var table = document.getElementById("collectionTable");
        // Create an empty <tr> element and add it to the 1st position of the table:
        var row = table.insertRow(index + 1);
        var cell1 = row.insertCell(0);
        var cell2 = row.insertCell(1);
        var cell3 = row.insertCell(2);
        var cell4 = row.insertCell(3);
        var cell5 = row.insertCell(4);
        // Add some text to the new cells:
        cell1.innerHTML = state;
        cell2.innerHTML = identifier;
        cell3.innerHTML = session;
        cell4.innerHTML = title;
        cell5.innerHTML = "<a href='/bills/" + encodeURIComponent(id) + "'>Read More</a>";
    });
}
