#!/bin/zsh

tuist install --update && tuist generate --no-open && pod install && open SearchAndSave.xcworkspace
