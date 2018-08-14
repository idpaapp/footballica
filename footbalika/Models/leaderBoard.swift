//
//  leaderBoard.swift
//  footbalika
//
//  Created by Saeed Rahmatolahi on 4/6/1397 AP.
//  Copyright © 1397 AP Saeed Rahmatolahi. All rights reserved.
//

import Foundation

public class  leaderBoard {
    public struct Response : Decodable {
        let status : String?
        let response : [response]?
    }
    
    public struct response : Decodable {
        let id : String?
        let username : String?
        let email : String?
        let email_connected : String?
        let password : String?
        let ref_id : String?
        let cups : String?
        let league_id : String?
        let level : String?
        let badge_name : String?
        let win_count : String?
        let draw_count : String?
        let lose_count : String?
        let clean_sheet_count : String?
        let six_on_row_count : String?
        let clean_sheet_streak_count : String?
        let win_streak_count : String?
        let no_lose_count : String?
        let game_count : String?
        let max_point : String?
        let max_wins_count : String?
        let max_points_gain : String?
        let stadium : String?
        let stadium_icon : String?
        let coins : String?
        let cashs : String?
        let level_gains : String?
        let real_level_gain : String?
        let avatar : String?
        let home_or_away : String?
        let user_type : String?
        let status : String?
        let extra_games : String?
        let finish_extra_time : String?
        let extra_type : String?
        let friend_id : String?
        let is_supports : String?
        let next_watch_video : String?
        let video : String?
        let view_type : String?
        let gem : String?
        let score : String?
    }
}
