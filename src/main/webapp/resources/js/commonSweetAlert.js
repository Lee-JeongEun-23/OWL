function errorAlert(message){
	callAlert("error", message);
}

function successAlert(message){
	callAlert("success", message);
}

function warningAlert(message){
	 callAlert("warning", message);
}

 function callAlert(icon, message){
	Swal.fire({
         icon: icon,
         title: message,
         showConfirmButton: false,
         timer: 1500
       })
}

function deleteAlert(cmd,bIdx){
	Swal.fire({
		  title: '정말 삭제하시겠습니까?',
		  icon: 'warning',
		  showCancelButton: true,
		  confirmButtonColor: '#3085d6',
		  cancelButtonColor: '#d33',
		  confirmButtonText: 'Yes'
		}).then((result) => {
		  if (result.value) {
			location.href= cmd+"bIdx="+bIdx;
		  }
		})
}