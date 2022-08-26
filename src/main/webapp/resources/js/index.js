function initMainController(type){
	$("#joinOkModal").on('show.bs.modal', function () {
        let interval = 3;
           let changeTime = setInterval(function(){
              if(interval < 0){
                 clearTimeout(changeTime);
                 $("#joinOkModal").modal("hide");
          		  $("#loginBtn").click();
              }
              
              $("#joinOkModal #changeTime").text(interval--);
           }, 1000)
    });
     openDialog(type);
     
     AOS.init(); //스크롤 애니메이션 
}

function openDialog(type) {
   if(!type) return;
   else if(type === "joinEmail") $("#opneJoinEmailModal").click();
   else if(type === "joinOk") {
      $('#joinOkModal').modal({backdrop: 'static', keyboard: false})  
      $("#opneJoinOkModal").click();
   }
}