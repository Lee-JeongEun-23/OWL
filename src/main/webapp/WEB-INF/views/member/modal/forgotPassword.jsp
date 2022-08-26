<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="modal fade" id="findPwdModal" tabindex="-1" role="dialog" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header text-center">
        <h4 class="modal-title w-100 font-weight-bold">Forgot your password?</h4>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body mx-3">
        <div class="mt-3 mb-3 login-input">
            <div class="form-group">
                <input type="email" name="email" class="form-control email" placeholder="Email">
            </div>
            <input type="button" class="btn btn loginButton btn-block waves-effect waves-light"  id="sendPwd" value="SEND">
        </div>
      </div>
    </div>
  </div>
</div>