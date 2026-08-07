---
layout: post
title: "REST Is Lazy. Use gRPC For Real Systems"
date: 2026-01-22 06:27:00 +0000
categories: software engineering
tags: [grpc, rest, protobuf, architecture]
excerpt_separator: <!--more-->
greeting: "contracts over loose json"
description: "A sharp comparison of REST and gRPC for internal service communication, with Protobuf and Java client examples for fintech systems."
image:
  url: assets/images/blog/2026-01-22-rest-is-lazy-use-grpc-for-real-systems-cover.png
  alt: "Rusty REST steam train being overtaken by a glowing gRPC bullet train"
---
REST is fine for many public APIs. For internal high-throughput service-to-service calls, JSON over HTTP often becomes lazy default, not deliberate choice.

If your fintech platform moves serious traffic between services, gRPC deserves attention.

<!--more-->

## JSON Is Expensive Flexibility

JSON is human-readable. It is also verbose, loosely typed, and easy to evolve badly.

Internal services do not need every payload to be readable in browser. They need fast serialization, strict contracts, streaming when useful, and generated clients.

## Protobuf Contract

~~~proto
syntax = "proto3";

package ledger.v1;

service LedgerService {
  rpc GetBalance(GetBalanceRequest) returns (GetBalanceResponse);
}

message GetBalanceRequest {
  string account_id = 1;
}

message GetBalanceResponse {
  string account_id = 1;
  string currency = 2;
  int64 minor_units = 3;
}
~~~

Fields have numbers. Contract is compiled. Client and server share exact shape.

## Java Client Shape

~~~java
ManagedChannel channel = ManagedChannelBuilder
    .forAddress("ledger", 9090)
    .usePlaintext()
    .build();

LedgerServiceGrpc.LedgerServiceBlockingStub ledger =
    LedgerServiceGrpc.newBlockingStub(channel)
        .withDeadlineAfter(200, TimeUnit.MILLISECONDS);

GetBalanceResponse response = ledger.getBalance(
    GetBalanceRequest.newBuilder()
        .setAccountId("acc-123")
        .build()
);
~~~

Deadline is explicit. Types are generated. Payload is binary.

## REST Still Has Place

Use REST for public APIs, browser clients, simple CRUD, and integration with external partners. It is universal and debuggable.

Use gRPC when internal contract stability, performance, streaming, and generated clients matter more.

## Trade-Offs

gRPC adds tooling, Protobuf discipline, gateway story for browsers, and different operational debugging. It is not magic powder.

But neither is REST. JSON endpoint with no schema, no versioning, and random nulls is not architecture.

## Final Rule

Choose protocol. Do not inherit it from tutorial.

If communication is internal, high-volume, and strongly typed, gRPC may be the adult option. REST is fine when you choose it with eyes open.

## Related reading

- [Microservices Are Not A Silver Bullet: You Probably Need A Monolith](/blog/microservices-are-not-a-silver-bullet/)
- [Your API Is A Mess: 5 Rules For Backward Compatibility](/blog/your-api-is-a-mess-5-rules-for-backward-compatibility/)
