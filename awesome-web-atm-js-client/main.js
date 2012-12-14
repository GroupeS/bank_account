/*
 license: MIT license
 author : Dimitri del Marmol
 Copyright: 2012- Dimitri del Marmol and others (pgcrism@users.sf.net)

*/

'use strict';
function value(id) {
  var value = $('#' + id).val();
  var parsed = parseInt(value);
  return _.isFinite(parsed) ? parsed : 0;
}

function display(id, value) {
  $('#' + id).val(value);
  $('#' + id).text(value);
}

function log(transaction) {
  var options = { interpolate: /\[\[(.+?)\]\]/g };
  var template = $("#transaction-template").text();
  var li = _.template(template, transaction, options);
  $('#log').prepend(li);
}

function refreshAccount(account) {
  display('number', account.number);
  display('balance', account.balance);
}

function refreshTransactions(transactions) {
  $('#log li').remove();
  _.each(_.sortBy(transactions, 'time'), log);
}

$(function () {
  $.ajax({
    url: 'http://localhost:9090/account/123',
    dataType: 'JSON',
    success: refreshAccount
  });
  $.ajax({
    url: 'http://localhost:9090/account/123/transactions',
    dataType: 'JSON',
    success: refreshTransactions
  });

  $('#amount').focus(function () { $(this).val('') })
  $('.operation').click(function (event) {
    var operation = $(event.target).data('operation');
    var oldBalance = value('balance');
    var amount = value('amount');

    $.ajax({
      url: 'http://localhost:9090/account/123/transactions',
      type: 'POST',
      dataType: 'JSON',
      data: {
        operation: operation,
        amount: value('amount')
      },
      success: function (response) {
        var transaction = response.response;
        log(transaction);
        display('balance', transaction.new_balance);
      }
    });
  });
});
