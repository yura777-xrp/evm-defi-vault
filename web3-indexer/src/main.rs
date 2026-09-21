use anyhow::Result;
use reqwest::Client;
use serde::{Deserialize, Serialize};

#[derive(Serialize)]
struct RpcRequest {
    jsonrpc: &'static str,
    id: u64,
    method: &'static str,
    params: Vec<serde_json::Value>,
}

#[derive(Deserialize, Debug)]
struct RpcResponse<T> {
    result: T,
}

#[tokio::main]
async fn main() -> Result<()> {
    let client = Client::new();

    let request = RpcRequest {
        jsonrpc: "2.0",
        id: 1,
        method: "eth_blockNumber",
        params: vec![],
    };

    let response: RpcResponse<String> = client
        .post("https://ethereum-rpc.publicnode.com")
        .json(&request)
        .send()
        .await?
        .json()
        .await?;

    println!("Latest Ethereum block: {}", response.result);

    Ok(())
}
