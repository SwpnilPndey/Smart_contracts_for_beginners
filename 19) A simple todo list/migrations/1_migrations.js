const todo = artifacts.require('TodoList');

module.exports=function(deployer) {
    deployer.deploy(todo);
}