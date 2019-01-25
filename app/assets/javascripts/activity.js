function getActive(bills) {
    var targetDate = document.getElementById("date").value;
    document.getElementById("results").innerHTML = "";
    for (i = 0;i < bills.length;i++) {
        var bill = bills[i];
        checkActivity(bill, targetDate);
    }
}

function checkActivity(bill, date) {
    var request = new XMLHttpRequest();
    // Open a new connection, using the GET request on the URL endpoint
    request.open('GET', '/billapi?date=' + date + '&id=' + bill["bill_id"] + '', true);
    request.onload = function () {
        // Begin accessing JSON data here
        if (this.response === "true") {
            var element = document.getElementById("results");
            var l = document.createElement('li');
            var a = document.createElement('a');
            var linkText = document.createTextNode(bill["bill_title"]);
            a.appendChild(linkText);
            a.title = bill["bill_title"];
            a.href = "/bills/" + encodeURIComponent(bill["bill_id"]);
            l.appendChild(a)
            element.appendChild(l);
        }
    }
    // Send request
    request.send();
}